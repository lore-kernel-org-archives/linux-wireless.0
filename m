Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:30644 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZBIWJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 17:09:17 -0500
Message-ID: <4990A988.6020307@gmail.com> (sfid-20090209_230923_013314_02A4C5AF)
Date: Mon, 09 Feb 2009 23:09:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Tobias Klauser <tklauser@distanz.ch>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] ath5k: Storage class should be before const qualifier
References: <20090209220540.GA7962@xenon.distanz.ch>
In-Reply-To: <20090209220540.GA7962@xenon.distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2009 11:05 PM, Tobias Klauser wrote:
> The C99 specification states in section 6.11.5:
> 
> The placement of a storage-class specifier other than at the beginning
> of the declaration specifiers in a declaration is an obsolescent
> feature.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Acked-by: Jiri Slaby <jirislaby@gmail.com>

