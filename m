Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2KZKcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 05:32:32 -0500
Message-ID: <1353925978.9488.11.camel@jlt4.sipsolutions.net> (sfid-20121126_113236_518914_F040F53B)
Subject: Re: [PATCH] mac80211: in ADHOC print debug message for every Auth
 message
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 11:32:58 +0100
In-Reply-To: <1353882267-27576-1-git-send-email-antonio@open-mesh.com>
References: <1353882267-27576-1-git-send-email-antonio@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-11-25 at 23:24 +0100, Antonio Quartulli wrote:
> The debug message has to be printed also for an Auth message with
> auth_sequence != 1. This helps understanding whether the two Auth
> messages are exchanged correctly or not.

Applied.

johannes

