Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52204 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbZLUTLm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 14:11:42 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Subject: Re: Can't turn off SSB (CONFIG_SSB)?
Date: Mon, 21 Dec 2009 20:11:37 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org
References: <4B2ECC72.40703@redfish-solutions.com> <20091221185922.GD4979@tuxdriver.com> <4B2FC783.7050709@redfish-solutions.com>
In-Reply-To: <4B2FC783.7050709@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200912212011.39364.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 21 December 2009 20:07:47 Philip A. Prindeville wrote:

> The issue is that later on when we build compat-wireless, then my .config file from the linux build directory gets sourced by that and we get a bunch of warnings from the b43, b44, etc. drivers that some ssb_* entry points are missing.

So, disable these drivers?

-- 
Greetings, Michael.
