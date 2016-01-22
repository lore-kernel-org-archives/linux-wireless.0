Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:32836 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbcAVUcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 15:32:18 -0500
Received: by mail-qg0-f67.google.com with SMTP id o11so5850234qge.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2016 12:32:18 -0800 (PST)
Date: Fri, 22 Jan 2016 15:30:08 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: Re: [PATCH 2/2] mac80211: let unused MPP table entries timeout
Message-ID: <20160122203008.GA4621@localhost> (sfid-20160122_213221_992353_11E805D1)
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453190672-9748-3-git-send-email-henning.rogge@fkie.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453190672-9748-3-git-send-email-henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2016 at 09:04:32AM +0100, Henning Rogge wrote:
> Remember the last time when a mpp table entry is used for
> rx or tx and remove them after MESH_PATH_EXPIRE time.

FYI I have a patch set I'm testing which rewrites a big chunk of
the path table stuff.

As I haven't posted it yet, I guess it doesn't matter if this
goes in first or not, I can adjust -- but it will conflict as-is.
I was hoping to post it early next week after a few fixes.

Let me know if you want me to base on top.

Shortlog looks like:

Bob Copeland (6):
      mac80211: mesh: move path tables into ieee82011_if_mesh
      mac80211: mesh: don't hash subif data in mesh path tables
      mac80211: mesh: factor out common mesh path allocation code
      mac80211: mesh: embed known gates list in struct mesh_path
      mac80211: mesh: convert path table to rhashtable
      mac80211: mesh: get rid of write-only field mean_chain_len

-- 
Bob Copeland %% http://bobcopeland.com/
