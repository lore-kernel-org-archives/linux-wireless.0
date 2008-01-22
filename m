Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:65376 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYAVBc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 20:32:28 -0500
Received: by an-out-0708.google.com with SMTP id d31so489214and.103
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2008 17:32:27 -0800 (PST)
Message-ID: <40f31dec0801211732g6c73c47aw121cdc6054a5fbbc@mail.gmail.com> (sfid-20080122_013231_072067_5E8AB7EA)
Date: Tue, 22 Jan 2008 03:32:27 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 2/3] ath5k: use SWBA to detect IBSS HW merges
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20080119091821.31251.5098.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080119091759.31251.60264.stgit@one>
	 <20080119091821.31251.5098.stgit@one>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +                                        /* XXX: only if VEOL suppported */

Hmm, seems we have to fix this in hw.c, veol seems to be supported on
5211 and above but i'm not sure (i'll check madwifi's capability bits
for each of my cards and implement get_capability better)...

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
