Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:52043 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbZF3QNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 12:13:14 -0400
Received: by yxe26 with SMTP id 26so318844yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 09:13:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246373403.13176.3.camel@jdl-desktop>
References: <1246310952.15012.22.camel@jdl-desktop> <1246345190.16256.1.camel@johannes.local>
	<1246373403.13176.3.camel@jdl-desktop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Jun 2009 09:12:57 -0700
Message-ID: <43e72e890906300912m724f9d17s772fe85dd69ae334@mail.gmail.com>
Subject: Re: [PATCH CRDA] Introduce separate HOST and TARGET compilation
	steps.
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2009 at 7:50 AM, Jon Loeliger<jdl@bigfootnetworks.com> wrote:
> On Tue, 2009-06-30 at 08:59 +0200, Johannes Berg wrote:
>> On Mon, 2009-06-29 at 16:29 -0500, Jon Loeliger wrote:
>> > The regdbdump tool is really a host executable that is used
>> > during the build process.  It could also be installed and
>> > used on the target, but two separate compilations are needed
>> > to achieve that goal.
>> >
>> > Currently, regdbdump is only built for the target, and thus
>> > cross-compilation of the tool is really feasible without
>> > this patch (or one like it).
>>
>> I don't think John is the correct addressee, Luis maintains this still,
>
> Oh!  Sorry!
>
>> afaik. The only thing I'm not sure about is the separation into host/
>> and target/,
>
> Do you have another suggestion?  Another approach would be to
> leave the "target" stuff in the top-level directory straight up,
> and bury the build of the host "tools" in a sub-directory?

As Pavel suggested can you split your work into separate patches? You
seem to do more than one thing and this patch is pretty large as is.

  Luis
