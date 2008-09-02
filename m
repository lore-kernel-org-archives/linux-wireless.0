Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:35342 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYIBXH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 19:07:28 -0400
Received: by nf-out-0910.google.com with SMTP id d3so440017nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2008 16:07:27 -0700 (PDT)
Message-ID: <1ba2fa240809021607s6855d3d3p411f13a940271f07@mail.gmail.com> (sfid-20080903_010733_552224_84CA8F69)
Date: Wed, 3 Sep 2008 02:07:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>, "Ian Schram" <ischram@telenet.be>
Subject: Re: pull request: wireless-2.6 2008-09-02
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080902221511.GH3050@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080902221511.GH3050@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> John W. Linville (1):
>      iwlwifi: do not use GFP_DMA in iwl_tx_queue_init
This one should be already in Yi's queue.The patch also address the
allocation error path. It's coauthored with Ian (out of Intel) so we
send it out just for record ... not sure what's the protocol.

Tomas
