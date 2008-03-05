Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:38172 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933787AbYCEM6Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 07:58:25 -0500
Date: Wed, 5 Mar 2008 13:56:34 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43legacy: Fix module init message
Message-ID: <20080305135634.113e7c14@morte> (sfid-20080305_125843_223188_0DC656E4)
In-Reply-To: <200803042031.13929.mb@bu3sch.de>
References: <200803042031.13929.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 4 Mar 2008 20:31:13 +0100
Michael Buesch <mb@bu3sch.de> wrote:

> This fixes the module init message to tell that the legacy
> driver loaded. This makes it less confusing, in case both drivers are loaded.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Acked-by: Stefano Brivio <stefano.brivio@polimi.it>


--
Ciao
Stefano
