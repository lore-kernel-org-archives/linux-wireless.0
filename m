Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1C3INz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 04:13:55 -0400
Subject: Re: [PATCH v5 10/10] nl80211: return mesh capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com
In-Reply-To: <1301450767-27045-11-git-send-email-thomas@cozybit.com>
References: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
	 <1301450767-27045-11-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 10:13:53 +0200
Message-ID: <1301472833.3935.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-29 at 19:06 -0700, Thomas Pedersen wrote:
> NL80211_CMD_GET_MESH_CONFIG now returns an NL80211_ATTR_MESH_CAPS
> containing the current capabilities of our mesh stack. This is useful
> for forward compatibility between old kernels and new userspace tools.

I think they should just be returned in the wiphy info, there's no
reason to create a mesh interface first to be able to query them, I
think?

johannes

