Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab1AKM7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 07:59:38 -0500
Subject: Re: [PATCH] mac80211:mesh_mpp_table_grow call should depend on
 MESH_WORK_GROW_MPP_TABLE flag.
From: Johannes Berg <johannes@sipsolutions.net>
To: nledovskikh@gmail.com
Cc: linville@tuxdriver.com, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110111143512.8161042b.nledovskikh@kodofon.vrn.ru>
References: <20110111143512.8161042b.nledovskikh@kodofon.vrn.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 13:59:35 +0100
Message-ID: <1294750775.3611.24.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 14:35 +0000, Nick Ledovskikh wrote:
> Replace MESH_WORK_GROW_MPATH_TABLE by MESH_WORK_GROW_MPP_TABLE in 
> mesh_mpp_table_grow call condition.

A changelog should explain "why" ... everybody can read "what" from the
patch already.

johannes

