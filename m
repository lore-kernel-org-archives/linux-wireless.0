Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:38355 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZAFB1s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 20:27:48 -0500
Subject: Re: Does Intel 5300 with iwlwifi support transmitter beamforming
 or calibration
From: Zhu Yi <yi.zhu@intel.com>
To: kai zeng <zengkai08@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <af77b8a80901051538k7f67573bhf69c45270ef380a4@mail.gmail.com>
References: <af77b8a80901051538k7f67573bhf69c45270ef380a4@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 09:26:41 +0800
Message-Id: <1231205201.11581.29.camel@debian> (sfid-20090106_022751_366683_464FF069)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-01-06 at 07:38 +0800, kai zeng wrote:
> Does anyone know if the Intel 5300 chipset with iwlwifi support
> transmitter beamforming or calibration.

Both are supported by the uCode. But Beamforming is not turned on by
default. That means the published uCode is not compiled with Beamforming
support.

Thanks,
-yi

