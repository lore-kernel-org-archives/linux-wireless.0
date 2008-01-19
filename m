Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:3954 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYASTdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 14:33:22 -0500
Received: by an-out-0708.google.com with SMTP id d31so312240and.103
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jan 2008 11:33:20 -0800 (PST)
Message-ID: <40f31dec0801191133o73e91fd0g97bd726c9f2bd7a7@mail.gmail.com> (sfid-20080119_193328_791279_00A188C4)
Date: Sat, 19 Jan 2008 21:33:20 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 3/3] ath5k: configure backoff for IBSS beacon queue
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20080119091841.31251.16946.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080119091759.31251.60264.stgit@one>
	 <20080119091841.31251.16946.stgit@one>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +               qi.tqi_cw_max = 2 * ah->ah_cw_min;

Have you checked ath5k_hw_reset_tx_queue ? cw_min/cw_max is
recalculated there, maybe we are doing something wrong there...





-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
