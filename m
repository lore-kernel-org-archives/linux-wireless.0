Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:21289 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYJ2LIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 07:08:09 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3246051rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 04:08:09 -0700 (PDT)
Message-ID: <40f31dec0810290408h5ee08c8l1e14d576064f01a4@mail.gmail.com> (sfid-20081029_120826_627686_C7015EFF)
Date: Wed, 29 Oct 2008 13:08:08 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Update PCU code
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
In-Reply-To: <20081029024603.GA22759@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081029021121.GA3079@makis>
	 <20081029024603.GA22759@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/29 Bob Copeland <me@bobcopeland.com>:
> On Wed, Oct 29, 2008 at 04:11:22AM +0200, Nick Kossifidis wrote:
>>  * Properly clean MIC key from keytable when TKIP is used (Bob is
>>  working on set_key function etc so i leave it for now).
>
> Heh, I was just prepping patches to send out.  I had basically the
> same thing for _reset_key too so I'll just rebase mine on top of this.
>

ACK, sorry for the bad coordination ;-(




-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
