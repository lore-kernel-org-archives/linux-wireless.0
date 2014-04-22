Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbaDVPJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 11:09:06 -0400
Message-ID: <1398179329.4211.16.camel@jlt4.sipsolutions.net> (sfid-20140422_170945_248575_45163BE5)
Subject: Re: [PATCH] mac80211: fixup radiotap tx flags for RTS/CTS
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, larrymaxwell@agilemesh.com,
	Bob Copeland <bob@cozybit.com>
Date: Tue, 22 Apr 2014 17:08:49 +0200
In-Reply-To: <1397651561-29820-1-git-send-email-me@bobcopeland.com> (sfid-20140416_143327_916041_72447019)
References: <1397651561-29820-1-git-send-email-me@bobcopeland.com>
	 (sfid-20140416_143327_916041_72447019)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-16 at 08:32 -0400, Bob Copeland wrote:
> When using RTS/CTS, the CTS-to-Self bit in radiotap TX flags is
> getting set instead of the RTS bit.  Set the correct one.

Good catch, applied.

johannes

