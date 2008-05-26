Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:60495 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbYEZJjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 05:39:08 -0400
Date: Mon, 26 May 2008 12:38:18 +0300
From: Jouni Malinen <j@w1.fi>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 2/5] hostap: fix references to 8802.11
Message-ID: <20080526093818.GH4932@jm.kir.nu> (sfid-20080526_113911_844809_EB9E40AC)
References: <20080523015442.16636.92254.stgit@dv.roinet.com> <20080523015448.16636.37283.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080523015448.16636.37283.stgit@dv.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2008 at 09:54:48PM -0400, Pavel Roskin wrote:
> 802.11 is meant in all cases.  The section numbers match the actual
> 802.11 standard.

Actually, 8802.11 was referring to ISO/IEC 8802-11, not IEEE 802.11..
Anyway, I do not have anything against changing this to refer to the
IEEE standard instead of ISO version of it.

-- 
Jouni Malinen                                            PGP id EFC895FA
