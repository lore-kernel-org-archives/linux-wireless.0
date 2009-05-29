Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47149
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbZE2WQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 18:16:51 -0400
Date: Fri, 29 May 2009 15:16:51 -0700 (PDT)
Message-Id: <20090529.151651.59612837.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-05-29
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090529132858.GA3520@tuxdriver.com>
References: <20090529132858.GA3520@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 29 May 2009 15:28:59 +0200

> Here are a couple of fixes that would be nice to have for 2.6.30 --
> nothing very controversial.  Each has a bugzilla.kernel.org entry listed
> in the changelog.
> 
> Please let me know if there are problems!

I know you're away and not at %100 but please do always CC:
netdev for your pull requests so that the attached patch gets
reviewed by networking folks and more importantly logged at:

	http://patchwork.ozlabs.org/project/netdev/list/

so that I can track it properly.

Thanks.
