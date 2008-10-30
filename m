Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:36072 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYJ3BTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 21:19:02 -0400
Message-ID: <b6c5339f0810291819ld7d6043k56b11128bc6252cb@mail.gmail.com> (sfid-20081030_021911_978084_75E29EFA)
Date: Wed, 29 Oct 2008 21:19:01 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-2.6 2008-10-29
Cc: "Arjan van de Ven" <arjan@infradead.org>, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, mcgrof@gmail.com, mickflemm@gmail.com
In-Reply-To: <20081029233350.GE3485@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081029231855.GD3485@tuxdriver.com>
	 <20081029162324.28f5864d@infradead.org>
	 <20081029233350.GE3485@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 7:33 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Oct 29, 2008 at 04:23:24PM -0700, Arjan van de Ven wrote:
>> On Wed, 29 Oct 2008 19:18:55 -0400
>> "John W. Linville" <linville@tuxdriver.com> wrote:
>> it seems to have added a few WARN_ON()s which now end up at the top of
>> the list .. are these known or should I spend some time writing reports
>> for netdev ?

Pavel Roskin posted one such WARN_ON to ath5k-devel a few days ago.
Seems related to setup of the rate tables, but I haven't reproduced it
here yet.  I'll see if he has more info...

-- 
Bob Copeland %% www.bobcopeland.com
