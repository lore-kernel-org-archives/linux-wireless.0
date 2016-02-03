Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56377 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbcBCJYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 04:24:20 -0500
Subject: Re: [PATCH v2] cfg80211: basic support for PBSS network type
To: Johannes Berg <johannes@sipsolutions.net>
References: <56961335.4040801@codeaurora.org>
 <1453807346.2759.29.camel@sipsolutions.net> <56A767E4.7090906@codeaurora.org>
 <1453812869.2759.38.camel@sipsolutions.net> <56A9D831.7070909@codeaurora.org>
 <1454425741.2926.7.camel@sipsolutions.net>
 <1454425840.2926.8.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Dedy Lansky <dlansky@codeaurora.org>,
	Maya Erez <merez@codeaurora.org>,
	Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
From: Lior David <liord@codeaurora.org>
Message-ID: <56B1C740.9020604@codeaurora.org> (sfid-20160203_102426_740941_C80C61B9)
Date: Wed, 3 Feb 2016 11:24:16 +0200
MIME-Version: 1.0
In-Reply-To: <1454425840.2926.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2/2/2016 5:10 PM, Johannes Berg wrote:
......
> Actually, one more question: Why does the kernel have to know at
> *connect* time that it should be a PBSS? It could tell that from the
> scan results, by looking for PBSS if it can't find AP in there, no?
> 
Yes it can be implemented that way. However we wanted user space to be able
to specify exactly whether to connect to an AP or PCP. Since PBSS is a separate
network type and we don't want clients to get an unexpected connection to
a PCP. We also don't want to support roaming between a PCP and AP (it is not
covered by the spec at this time)

Thanks,
Lior
