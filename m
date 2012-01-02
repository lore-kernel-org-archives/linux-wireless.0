Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51379 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab2ABNlh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 08:41:37 -0500
Message-ID: <4F01B408.1080900@openwrt.org> (sfid-20120102_144154_277363_712DE366)
Date: Mon, 02 Jan 2012 14:41:28 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	m.sujith@gmail.com, ath9k-devel@lists.ath9k.org
Subject: Re: [RFC] ath9k_hw: make use of ar9003_calc_ptr_chksum
References: <1325509985-11720-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1325509985-11720-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-02 2:13 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> make use of the already available function 'ar9003_calc_ptr_chksum'
> in 'ar9003_set_txdesc'
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
NACK. I intentionally did not use that function to avoid unnecessary
access to uncached memory (for performance reasons).

- Felix
