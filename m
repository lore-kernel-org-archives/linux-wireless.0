Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0104.hostedemail.com ([216.40.44.104]:57119 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752146AbcCVRhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 13:37:05 -0400
Message-ID: <1458668219.8482.23.camel@perches.com> (sfid-20160322_183756_802971_2C8A38DE)
Subject: Re: [PATCH] ath9k: fix checkpatch.pl identation and sapce errors.
From: Joe Perches <joe@perches.com>
To: Ashwini Singh <Ashwini_Singh@mentor.com>,
	ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rajeev_Kumar@mentor.com
Date: Tue, 22 Mar 2016 10:36:59 -0700
In-Reply-To: <1458629628-6264-1-git-send-email-Ashwini_Singh@mentor.com>
References: <1458629628-6264-1-git-send-email-Ashwini_Singh@mentor.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-22 at 12:23 +0530, Ashwini Singh wrote:
> Signed-off-by: Ashwini Singh <Ashwini_Singh@mentor.com>

It might be better to break this into a few different patches.

o Remove trailing whitespace
o Fix vertical line / brace location
o Multi-line statement parenthesis alignment
o Space to tab conversions
o Whitespace addition / removal

