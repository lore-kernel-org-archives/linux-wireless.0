Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:56001 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755247Ab1K3Cg4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 21:36:56 -0500
Message-ID: <20111130023650.19520.qmail@stuge.se> (sfid-20111130_033701_191846_308DE45D)
Date: Wed, 30 Nov 2011 03:36:50 +0100
From: Peter Stuge <peter@stuge.se>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: validate for non-zero BSSID
References: <1322576540-13751-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1322576540-13751-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> before concluding that the recieved beacon is for us, let us make sure
> that the BSSID is non-zero.

Under what circumstances would the BSSID be zero?


//Peter
