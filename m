Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44866 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZHESbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 14:31:03 -0400
Date: Wed, 5 Aug 2009 14:20:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andreas Steinmetz <ast@domdv.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb entry for DE wrong
Message-ID: <20090805182040.GD20338@tuxdriver.com>
References: <4A71A6BE.20304@domdv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4A71A6BE.20304@domdv.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2009 at 03:57:18PM +0200, Andreas Steinmetz wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> [please CC me as I'm not subscribed]
> 
> Error in regulatory database for country DE:
> 
> The document
> 
> http://www.bundesnetzagentur.de/media/archive/5009.pdf
> 
> states that the frequency range from 5470 GHz to 5725 GHz can be used
> indoor and outdoor, thus the NO-OUTDOOR flag for this range is wrong.
> 
> Quick and dirty translation of the relevant text from this document
> including the note:
> 
> Usage indoor and outdoor. Transmission between within a plane and a
> location outside of a plane prohibited.

Post a patch?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
