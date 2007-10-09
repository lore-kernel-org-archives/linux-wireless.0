Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:8966 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXJIMOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 08:14:18 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: clean up scan debug messages
Date: Tue, 9 Oct 2007 14:14:28 +0200
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
References: <200710091344.31107.hs4233@mail.mn-solutions.de>
In-Reply-To: <200710091344.31107.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710091414.28401.hs4233@mail.mn-solutions.de> (sfid-20071009_131445_996165_32386A29)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -	lbs_deb_enter(LBS_DEB_ASSOC);
> +	lbs_deb_enter_args(LBS_DEB_SCAN, "maxchanperscan %d, filteredscan %d, "
> +		full_scan %d", maxchanperscan, filteredscan, full_scan);

Uhh, oh, missing "

After fiddling a patch so that checkpatch.pl doesn't bark anymore,
one should at least try to compile the kernel ...

Sending take 2 in a minute :-(
