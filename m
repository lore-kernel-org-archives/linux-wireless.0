Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33016 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0BWWzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 17:55:42 -0500
Received: by gwj16 with SMTP id 16so797297gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2010 14:55:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266956262.16604.1.camel@mj>
References: <20100219012802.12460.42239.stgit@mj.roinet.com>
	 <20100219134448.GA2844@tuxdriver.com> <1266621325.25707.14.camel@mj>
	 <b6c5339f1002200730t46298538k30930ed52255f06e@mail.gmail.com>
	 <1266956262.16604.1.camel@mj>
Date: Tue, 23 Feb 2010 17:55:38 -0500
Message-ID: <b6c5339f1002231455j3b861d40h8ba9cb83346b90c2@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/3] ath5k: remove stale function
	declarations, make some functions static
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2010 at 3:17 PM, Pavel Roskin <proski@gnu.org> wrote:
>> Maybe one or two functions are waiting on an API in the stack to be useful
>> (e.g. antenna stuff), but we can always get these routines back from git
>> history if need be.
>
> I see you are doing that work already, so please just tell me if I need
> to resubmit my patches.

Who, me?  I think you have me confused with Bruno.  Or was that the
plural you? :)

I think the patches are fine, with or without the functions, so we can just
do whatever keeps John happy.

-- 
Bob Copeland %% www.bobcopeland.com
