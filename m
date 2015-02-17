Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43876 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbBQPtb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 10:49:31 -0500
Date: Tue, 17 Feb 2015 15:48:55 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v2] wlcore: add basic device-tree support
Message-ID: <20150217154855.GQ8994@leverpostej> (sfid-20150217_164935_288195_24BBA77F)
References: <1423998550-8829-1-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423998550-8829-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[...]

> +	wlcore: wlcore@0 {
> +		compatible = "ti,wlcore";
> +		reg = <2>;

Nit: the reg and unit-address (the bit after the '@' in the node name)
should match.

Mark.
