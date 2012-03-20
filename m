Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37133 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab2CTP4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 11:56:09 -0400
Message-ID: <4F68A893.7000108@qca.qualcomm.com> (sfid-20120320_165613_925050_5B23C208)
Date: Tue, 20 Mar 2012 17:56:03 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Thiruvengadam, Aarthi" <athiruve@qca.qualcomm.com>
CC: ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath6kl: handle probe response from P2P device in P2P
 GO mode
References: <1331847296-2086-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com> <4F684247.6070800@qca.qualcomm.com> <EEF58C4275060743A995E9DD768A2A5227B4B27D@nasanexd02c.na.qualcomm.com>
In-Reply-To: <EEF58C4275060743A995E9DD768A2A5227B4B27D@nasanexd02c.na.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2012 05:54 PM, Thiruvengadam, Aarthi wrote:

> According to the standard (section 7.2.3.9), SSID always follows the
> capability information in a probe response frame. So I think we
> should be ok as long as we check the buffer length.

Ok, thanks for the confirmation.

Kalle
