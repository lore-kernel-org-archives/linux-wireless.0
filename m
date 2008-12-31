Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:60753 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbYLaROP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 12:14:15 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
Date: Wed, 31 Dec 2008 18:16:34 +0100
Cc: htl10@users.sourceforge.net,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
References: <348894.23448.qm@web23108.mail.ird.yahoo.com> <495B82CB.6050205@tuffmail.co.uk>
In-Reply-To: <495B82CB.6050205@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200812311816.36670.oliver@neukum.org> (sfid-20081231_181421_738587_337592D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 31. Dezember 2008 15:33:47 schrieb Alan Jenkins:
> Thanks for the patch. =C2=A0I tested STD too, and it doesn't seem to =
hang
> anymore. =C2=A0I even tested removing the adaptor while the system wa=
s
> hibernated. =C2=A0However, after resume the interface is useless.

=46or STD you need to implement reset_resume()

	Regards
		Oliver

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
