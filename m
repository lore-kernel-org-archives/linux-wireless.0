Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:36217 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934907AbcA0TkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 14:40:03 -0500
Received: by mail-qg0-f67.google.com with SMTP id 6so1141545qgy.3
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2016 11:40:03 -0800 (PST)
Date: Wed, 27 Jan 2016 14:39:56 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Peter Oh <poh@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] ath10k: rename mesh and add abstraction layer
Message-ID: <20160127193955.GC12639@localhost> (sfid-20160127_204013_003424_8504A457)
References: <1453920957-9908-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453920957-9908-1-git-send-email-poh@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 27, 2016 at 10:55:53AM -0800, Peter Oh wrote:
> Split Mesh service to 11s Mesh and non-11s Mesh according to
> firmware service bit to help users distinguish 11s Mesh from
> non 11s Mesh.
> And add abstraction layer for vdev subtype to solve subtype mismatch
> and to give flexible compatibility among different firmware revisions.

Out of curiosity, which non-11s mesh, if you can share?

-- 
Bob Copeland %% http://bobcopeland.com/
