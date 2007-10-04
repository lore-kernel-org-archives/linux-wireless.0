Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:49231 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbXJDEND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 00:13:03 -0400
Date: Wed, 3 Oct 2007 21:12:27 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: don't try setting the generic IE to the kernel
Message-ID: <20071004041227.GN933@jm.kir.nu> (sfid-20071004_051307_445195_1B9BF48A)
References: <1190811258.4204.7.camel@johannes.berg> <20071003030150.GG933@jm.kir.nu> <1191394054.4178.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1191394054.4178.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 03, 2007 at 08:47:34AM +0200, Johannes Berg wrote:
> On Tue, 2007-10-02 at 20:01 -0700, Jouni Malinen wrote:
> > hostapd_set_generic_elem() wrapper for this driver wrapper function
> > should return 0 if the wrapper is not implemented (function pointer is
> > NULL).. Did I miss something or shouldn't we just remove
> > i802_set_generic_elem() function completely instead of leaving the empty
> > "return 0" version in?
> 
> Oh no you're right, somehow I was under the impression that the wrapper
> function returned an error if it wasn't implemented. Want a new patch?

No need for a new patch; I applied your patch with a modification of
jusr removing the function completely.

-- 
Jouni Malinen                                            PGP id EFC895FA
