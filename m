Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.hevs.ch ([153.109.23.10]:56578 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYBZQSl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 11:18:41 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 2] libertas: implement SSID scanning for SIOCSIWSCAN
Date: Tue, 26 Feb 2008 16:44:04 +0100
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
References: <200802261522.05676.hs4233@mail.mn-solutions.de>
In-Reply-To: <200802261522.05676.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Message-Id: <200802261644.05300.marc.pignat@hevs.ch> (sfid-20080226_161845_355997_DFCDA98D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 26 February 2008, Holger Schurig wrote:
> libertas: implement SSID scanning for SIOCSIWSCAN
> 
> After my bit scan re-writing the SIOCSIWSCAN wext ioctl no longer supported
> scanning for a specific SSID. However, wpa_supplicant is a possible user of
> this ioctl, so here is code that add's this.
> 
> While passing, removed even more of the debugfs-based scanning. You can (and
> should) the SIOCSIWSCAN to ask for scans, so there is no need for
Seems you have forgotten the 'use' word :)

> proprietary interfaces for scanning. And, besides, the scan result couldn't
> be used further, e.g. not for associating.
..

Regards

Marc
