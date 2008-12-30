Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:47292 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbYL3SDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 13:03:40 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
Date: Tue, 30 Dec 2008 19:05:44 +0100
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Alan Stern <stern@rowland.harvard.edu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
References: <Pine.LNX.4.44L0.0812301220090.2386-100000@iolanthe.rowland.org> <495A5AE5.1040902@tuffmail.co.uk> <495A5FEC.5070608@lwfinger.net>
In-Reply-To: <495A5FEC.5070608@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200812301905.46215.oliver@neukum.org> (sfid-20081230_190346_968311_94880991)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 30. Dezember 2008 18:52:44 schrieb Larry Finger:
> Alan Jenkins wrote:
> > That won't fix hibernation though. =A0The disconnect method can sti=
ll get
> > called in resume from hibernation, before the workqueue gets unfroz=
en.=20
> > To be honest, I'm far more interested in suspend-to-disk than
> > suspend-to-ram.
>=20
> Does this patch fix your problem? It works here, but I only did one
> test. The patch is for wireless-testing.

Did you test STD or STR?

	Regards
		Oliver

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
