Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3476 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab0IQDfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 23:35:22 -0400
Date: Thu, 16 Sep 2010 23:32:24 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 02/11] This change reorganizes the main ath5k file in
	order to re-group
Message-ID: <20100917033224.GB32630@hash.localnet>
References: <20100917023543.24997.48466.stgit@tt-desk> <20100917023630.24997.40997.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100917023630.24997.40997.stgit@tt-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 17, 2010 at 11:36:30AM +0900, Bruno Randolf wrote:
> From: Bob Copeland <me@bobcopeland.com>
> 
> related functions and remove most of the forward declarations
> (from 61 down to 3).  This is, unfortunately, a lot of churn, but
> there should be no functional changes.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> Signed-off-by: Bruno Randolf <br1@einfach.org>

> Bruno: rebased to wireless-next

I'm happy that you did the work :) but something weird happened
to the commit log: subject is gone and first line of the message
became the subject.

-- 
Bob Copeland %% www.bobcopeland.com

