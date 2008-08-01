Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:26960 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYHAPZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 11:25:44 -0400
Received: by fg-out-1718.google.com with SMTP id 19so546916fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 08:25:42 -0700 (PDT)
Message-ID: <48932AFA.5020903@gmail.com> (sfid-20080801_172548_706905_EAB36A85)
Date: Fri, 01 Aug 2008 17:25:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Bob Copeland <me@bobcopeland.com>, tomasw@gmail.com,
	Dave Young <hidave.darkstar@gmail.com>, stable@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linville@tuxdriver.com, Pekka Enberg <penberg@cs.helsinki.fi>,
	ath5k-devel@venema.h4ckr.net, johannes@sipsolutions.net,
	Andrew Morton <akpm@linux-foundation.org>
Subject: git-describe [Was: ath5k_config_interface deadlock fix]
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>		<4892C359.9000304@cs.helsinki.fi>		<20080801011415.ff4821a3.akpm@linux-foundation.org>	<b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com> <4893257C.1020907@gmail.com> <48932A10.8080004@tuffmail.co.uk>
In-Reply-To: <48932A10.8080004@tuffmail.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Jenkins napsal(a):
> There must be a better way (for efficient merges, right?).  But all I
> can think of is comparing the files in question against the diff.  I
> checked myself and the changes don't appear to have been included in
> v2.6.26.

Ah, I see. Is this a git-describe bug or my misunderstanding of the tool?

Sorry for the noise, it's not in 2.6.26.
