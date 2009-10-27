Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35900 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753473AbZJ0DpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 23:45:22 -0400
Date: Mon, 26 Oct 2009 20:45:14 -0700
From: Jouni Malinen <j@w1.fi>
To: Holger Schurig <h.schurig@mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: RECAP: indication of channel noise
Message-ID: <20091027034514.GA20995@jm.kir.nu>
References: <200910261442.44774.h.schurig@mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200910261442.44774.h.schurig@mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 02:42:44PM +0100, Holger Schurig wrote:

> The idea is to have one API call "do site survey", where you tell 
> the driver to scan on specified/all channels to determine those 
> values.

What would this command be? Just the existing scan trigger command with
a new attribute indicating that site survey is requested? In my first
use case (select best channel for an AP), I would like to combine the
normal scan (get all BSSes) and site survey (get tx/rx/idle hw counters
for each channel). Fetching the site survey data with a new command
would be fine, but trigger command should be shared.

-- 
Jouni Malinen                                            PGP id EFC895FA
