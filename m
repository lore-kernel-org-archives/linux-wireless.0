Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36196 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbcCDPX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 10:23:29 -0500
Received: by mail-qk0-f172.google.com with SMTP id s68so22026949qkh.3
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2016 07:23:29 -0800 (PST)
Received: from hash ([2001:470:1d:6db:230:48ff:fe9d:9c89])
        by smtp.gmail.com with ESMTPSA id e79sm1817070qkj.2.2016.03.04.07.23.28
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Mar 2016 07:23:28 -0800 (PST)
Received: from bob by hash with local (Exim 4.84)
	(envelope-from <me@bobcopeland.com>)
	id 1abrZf-0003Bs-8H
	for linux-wireless@vger.kernel.org; Fri, 04 Mar 2016 10:23:27 -0500
Date: Fri, 4 Mar 2016 10:23:27 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Subject: refcnt fix in wireless-testing
Message-ID: <20160304152326.GF19848@localhost> (sfid-20160304_162349_721010_42329FFA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a quick note that if you are using a recent wireless-testing,
there's a reference counting bug which was fixed in net-next:

    https://git.kernel.org/davem/net-next/c/799977d9aaf

I've cherry-picked this commit for today's build and will keep doing
so for the 4.5.x series or until no longer needed.

-- 
Bob Copeland %% http://bobcopeland.com/
