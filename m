Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54204 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2L3O3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2012 09:29:43 -0500
Received: by mail-ob0-f178.google.com with SMTP id eh20so10736840obb.23
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2012 06:29:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADPh3e6rL3V=3Nr4w8P8ZCKeT-VjqT45NHtp_narFsp1kaGjKg@mail.gmail.com>
References: <CADPh3e6rL3V=3Nr4w8P8ZCKeT-VjqT45NHtp_narFsp1kaGjKg@mail.gmail.com>
Date: Sun, 30 Dec 2012 19:51:32 +0530
Message-ID: <CAD2nsn1EFZ+P1zEP7gVzDtnzarQNpesDyWmEmgs1-xSxNgZLOQ@mail.gmail.com> (sfid-20121230_152947_952118_F06D4656)
Subject: Re: ar3012 bluetooth nor working
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: HariHara Sudhan <hari@emo2.com>
Cc: linux-wireless@vger.kernel.org,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 8, 2012 at 4:17 PM, HariHara Sudhan <hari@emo2.com> wrote:
> I've a ar9485 +ar3012 combo card and using .
>  Wifi is working fine with ath9k drivers.
> But for bluetooth i've enabled BT_ATH3k use in kernel. And it loaded btusb ,
> bnep, rfcomm modules. ath3k wasn't comming up, and hcitool scan
> results gave me nothing.
> rfkill shows both wwifi and bluetooth devices are not blocked.
>
> so it is told in ath3k drivers guide from your website . i've added
> the id's in ath3k support list and btusb blacklist.
> Now ath3k is loaded when i checked lsmod, and btusb is also loaded .
> But now rfkill is not showing bluetooth device and hcitool scan says
> "Device Not abailable".
> What could be the reason.
> BTW blacklist driverinfo i gave was "BTUSB_IGNORE
>
> --
> Regards
>
> HariHaraSudhan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

you can give us the vid, PID. we can come up with a patch and see if
works for you.


-- 
thanks,
shafi
