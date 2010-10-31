Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19426 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab0JaP2M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Oct 2010 11:28:12 -0400
Subject: Re: Deauthentication for reason 6 using Intel 5300 in 2.6.34
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4CCCE31A.5030608@lwfinger.net>
References: <4CCCE31A.5030608@lwfinger.net>
Content-Type: text/plain
Date: Sun, 31 Oct 2010 08:26:59 -0700
Message-Id: <1288538819.14805.13.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Sat, 2010-10-30 at 20:31 -0700, Larry Finger wrote:
> A user on the openSUSE forum reports that the connection drops frequently when
> using 802.11n on a 5300 with a 2.6.34 kernel. It is deauthenticated for reason
> 6. He was able to stabilize the connection by disabling N mode. I think he used
> "options iwlagn 11n_disable=1 11n_disable50=1".
> 
> Is this a known problem? Would the situation be improved by using
> compat-wireless? If so, is "bleeding-edge" needed?
I could be the same "tid not match" problem we seen on 2.6.35, but
different behavior. We are really working hard and try to release the
experimental versoin of the uCode; but we have to pass the regulatory
first which cause delay. I understand the need for it and I am working
my best to push it happen ASAP.

Thanks
Wey 

