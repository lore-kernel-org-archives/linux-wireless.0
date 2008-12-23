Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbYLWOMH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 09:12:07 -0500
Date: Tue, 23 Dec 2008 12:11:55 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, simon@thekelleys.org.uk,
	jussi.kivilinna@mbnet.fi, pe1rxq@amsat.org
Subject: Re: [PATCH] wireless: Add channel/frequency conversions to
	ieee80211.h
Message-ID: <20081223141155.GB6981@ghostprotocols.net> (sfid-20081223_151213_909169_A72AF7BF)
References: <1230041018-13341-1-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1230041018-13341-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Tue, Dec 23, 2008 at 02:03:38PM +0000, David Kilroy escreveu:
> Added mappings for FHSS, DSSS and OFDM channels - with macros to point
> HR DSSS and ERP to the DSSS mappings. Currently just static inline
> functions.
> 
> Use the new functions in the older fullmac drivers. This eliminates a
> number of const static buffers and removes a couple of range checks that
> are now redundant.
> 
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
