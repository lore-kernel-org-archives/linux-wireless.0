Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:60333 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0J0MOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 08:14:01 -0400
Date: Wed, 27 Oct 2010 13:13:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: sedat.dilek@gmail.com, LKML <linux-kernel@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org,
	DRI <dri-devel@lists.freedesktop.org>,
	acpi4asus-user@lists.sourceforge.net,
	Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
	linux-wireless@vger.kernel.org
Subject: Re: drivers/platform/x86: Backlight-Add-backlight-type-v2.patch
Message-ID: <20101027121353.GA5863@srcf.ucam.org>
References: <AANLkTikwo++xG7SXzNPwmZgU2jbdLiMr0Wi+vaxFqb7o@mail.gmail.com> <AANLkTi=NcpzcUv8jx5_NYxxBp8y0F2-Uh8aCCacb-ZWN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=NcpzcUv8jx5_NYxxBp8y0F2-Uh8aCCacb-ZWN@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The parent of the backlight doesn't let you determine whether it's a 
platform or a firmware interface without heuristics. I'd prefer to 
explicitly define that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
