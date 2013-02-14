Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39052 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3BNEp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 23:45:27 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so1524234wgb.11
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2013 20:45:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <511C65F2.1080201@gnoutcheff.name>
References: <5100BEF7.4000107@gnoutcheff.name> <CAGRGNgWg=4CgjXpdceNfsy6X0_q=SFY8CegJsTf60yGd_NBuLQ@mail.gmail.com>
 <511C65F2.1080201@gnoutcheff.name>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 14 Feb 2013 15:45:05 +1100
Message-ID: <CAGRGNgWQqNXdN1ke2AaVM3eiRMupq1G22MCC=ZBZTXDKwPwbgw@mail.gmail.com> (sfid-20130214_054530_321151_03005BB8)
Subject: Re: [ath5k] [bugreport] BIOS hang if wifi was connected before reboot
To: Daniel Gnoutcheff <daniel@gnoutcheff.name>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On Thu, Feb 14, 2013 at 3:20 PM, Daniel Gnoutcheff
<daniel@gnoutcheff.name> wrote:
> Hello Julian, thanks for your response and advice.  (Sorry for my very
> slow reply.)
>
> On 01/24/2013 01:45 AM, Julian Calaby wrote:
>> On Thu, Jan 24, 2013 at 3:56 PM, Daniel Gnoutcheff
>> <daniel@gnoutcheff.name> wrote:
>>> Up until recently, it seems that NetworkManager would always disconnect upon
>>> shutdown and thus avoided this bug, but this changed in Ubuntu 12.10.
> <snip>
>>
>> Have you raised a bug with Ubuntu's Network Manager maintainers about this?
>
> I have now.  Upon investigation, it appears that this is caused by a
> combination of (upstream) bugs in wpa_supplicant and NetworkManager.
> Fixing either of these bugs restores the intended behavior (and is an
> effective workaround for the BIOS bug).  The NetworkManager bug has
> already been fixed in upstream's git.  For the record, the relevant bug
> reports are:
>
> For NetworkManager:
>   https://bugs.launchpad.net/network-manager/+bug/1124803
>   https://bugzilla.gnome.org/show_bug.cgi?id=683932
> For wpa_supplicant:
>   https://bugs.launchpad.net/ubuntu/+source/wpa/+bug/1124789
>   http://w1.fi/bugz/show_bug.cgi?id=474

Good work, hopefully those fixes get pushed out soon.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
