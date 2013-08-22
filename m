Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:60646 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3HVRNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 13:13:46 -0400
Received: by mail-qa0-f52.google.com with SMTP id bq6so466055qab.18
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2013 10:13:46 -0700 (PDT)
Date: Thu, 22 Aug 2013 13:13:13 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	distro11s@cozybit.com
Subject: Re: [PATCH v2] mac80211: only respond to probe request with mesh ID
Message-ID: <20130822171312.GE23629@localhost> (sfid-20130822_191349_661922_923F2E9F)
References: <1377190892-5328-1-git-send-email-yeohchunyeow@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377190892-5328-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 22, 2013 at 10:01:32AM -0700, Chun-Yeow Yeoh wrote:
> +	if(!elems.mesh_id)
> +		return;
> +

if (!elems.mesh_id)

(checkpatch will warn about that)

-- 
Bob Copeland %% www.bobcopeland.com
