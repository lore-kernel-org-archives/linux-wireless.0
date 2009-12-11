Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:49907 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbZLKQmC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 11:42:02 -0500
Received: by iwn1 with SMTP id 1so554807iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2009 08:42:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200912111739.55225.holgerschurig@gmail.com>
References: <500577.32161.qm@web51405.mail.re2.yahoo.com> <200912101846.40572.holgerschurig@gmail.com>
	<43e72e890912100914m1766db5fife6563fec3807b8d@mail.gmail.com>
	<200912111739.55225.holgerschurig@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 11 Dec 2009 08:41:48 -0800
Message-ID: <43e72e890912110841k2a49ec19w9e29ad66a9165030@mail.gmail.com>
Subject: Re: Switching channel in IBSS network doesn't work in ath9k
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: Joerg Pommnitz <pommnitz@yahoo.com>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 11, 2009 at 8:39 AM, Holger Schurig
<holgerschurig@googlemail.com> wrote:
>> Actually I think a simple 'iw link' to do this for all interfaces
>> would be good. I just haven't gotten around to it. I should be
>> possible without upstream changes I believe.
>
> Do you think that "iw link" should also show then info when the device is in
> monitor mode (e.g. return the flags) or in IBSS mode?  And probably also
> reporting parts of the survey data, e.g. noise floor?
>
> That would be the equivalent of a "give me the greatest amount of info
> quickly" :-)

I do but johill is the maintainer, see what he thinks :)

  Luis
