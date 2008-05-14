Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38819 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYENTWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 15:22:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 5/5] b43: move the register write into radio2050_rfover_val
Date: Wed, 14 May 2008 21:22:21 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <1210791396.6191.40.camel@brick>
In-Reply-To: <1210791396.6191.40.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805142122.21635.mb@bu3sch.de> (sfid-20080514_212254_756904_98872A78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 May 2008 20:56:36 Harvey Harrison wrote:
> It is always called with the same dev, register value as the
> b43_phy_write that wraps around it, make it return void
> and move the register write into radio2050_rfover_val.

NACK to the whole 5 patches.
See the list archives for an explanation.

-- 
Greetings Michael.
