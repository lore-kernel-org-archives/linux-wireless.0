Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48835 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GCPpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 11:45:16 -0400
Received: by pbbrp8 with SMTP id rp8so9413658pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 08:45:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341322180.20124.4.camel@jlt3.sipsolutions.net>
References: <E50901D4F2CF69428D43141B7C85867929E154AE7B@EXMB03.eu.tieto.com> <1341322180.20124.4.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 3 Jul 2012 08:44:55 -0700
Message-ID: <CAB=NE6XJj4pQZ+nB+yWp16n=t9CahhEi+tFuJ9KbGtvjc0K3yA@mail.gmail.com> (sfid-20120703_174521_098957_7E54239E)
Subject: Re: wlan automated tests
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Piotr.Nakraszewicz@tieto.com, linux-wireless@vger.kernel.org,
	filip.matusiak@tieto.com, pstew@chromium.org,
	Kathy Giori <kgiori@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 6:29 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2012-07-03 at 15:47 +0300, Piotr.Nakraszewicz@tieto.com wrote:
>
>> 1. wifi-test:
>> http://wireless.kernel.org/en/developers/Testing/wifi-test
>> But it looks dead. Last commit is from 2010.
>
> This is definitely dead.
>
>> 2. LTP:
>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/19759
>> http://thread.gmane.org/gmane.linux.ltp/7884
>
> I don't know about this.
>
>> 3. Chromium Wifi tests:
>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/57576
>
> But I think this is probably the best one to extend.

Indeed, in fact I'm hoping somewhere out there AP mode operation can
be extended to the framework by some entity.

  Luis
