Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65533 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1LVOmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 09:42:01 -0500
Received: by qcqz2 with SMTP id z2so5032983qcq.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 06:42:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111222141102.GA2261@redhat.com>
References: <CAA=oPaiE-NAP_rfi3BLv-wM_wBwfLyMh-p2KtMALXPaDG6LxxA@mail.gmail.com>
	<20111222141102.GA2261@redhat.com>
Date: Thu, 22 Dec 2011 15:42:00 +0100
Message-ID: <CAA=oPajYJQoz0AhAaGuY9y=2gbMUfpBZJU71TmryG_zksQk_Nw@mail.gmail.com> (sfid-20111222_154205_440151_7D58B479)
Subject: Re: rt2800usb poor performance
From: Christian Frost <cf@cfrost.dk>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, I have tried all your suggestions and they do not help. I
havedownloaded the firmware from ralinktech in version v2.4.0.1

Christian
On Thu, Dec 22, 2011 at 3:11 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Dec 22, 2011 at 12:44:17PM +0100, Christian Frost wrote:
>> I'm experiencing poor performance with a rt2800usb device when using
>> "compat-wireless-3.2-rc6-3" on a 2.6.35 kernel. The bandwidth is
>> ~0.5Mbps which I would expect to be significantly higher on a G
>> network. Can anyone help with this?
>
> Do you have any better results on older compat wireless version i.e.
> 3.0 or 3.1. Does disable power save helps (iwconfig wlanX power off)?
> Did you try update AP firmware?
>
> Stanislaw
