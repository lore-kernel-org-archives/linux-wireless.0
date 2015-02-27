Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:60068 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbbB0IOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 03:14:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 1/2] dt: bindings: add wl18xx wireless device
Date: Fri, 27 Feb 2015 09:14:39 +0100
Message-ID: <36252734.kTKJHJAt2s@wuerfel> (sfid-20150227_091509_488949_65682285)
In-Reply-To: <1424362401-8228-1-git-send-email-eliad@wizery.com>
References: <1424362401-8228-1-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 19 February 2015 18:13:20 Eliad Peller wrote:
> +Required properties:
> + - compatible : Should be "ti,wl18xx".

Do not use wildcards in the compatible string, use specific model numbers.

	Arnd
