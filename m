Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28223 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYJ1TZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 15:25:25 -0400
Subject: Re: iwl4965 crash in iwl-tx.c
From: reinette chatre <reinette.chatre@intel.com>
To: Bernard Moret <bernard.moret@epfl.ch>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Noah Meyerhans <frodo@morgul.net>
In-Reply-To: <38961a360810281132n660baefbk8c8b3eb8cf144edb@mail.gmail.com>
References: <20081024180514.GA14438@morgul.net>
	 <20081024185419.GA19057@tuxdriver.com>	 <20081024191700.GD14438@morgul.net>
	 <1225215583.1115.195.camel@rc-desk>
	 <38961a360810281132n660baefbk8c8b3eb8cf144edb@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 12:25:49 -0700
Message-Id: <1225221949.1115.208.camel@rc-desk> (sfid-20081028_202528_317327_48395A8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(including linux-wireless)

On Tue, 2008-10-28 at 11:32 -0700, Bernard Moret wrote:
> Hello!
> I can confirm that the bug no longer exists (or has become very
> hard to trigger!) in 2.6.28-rc2.
> I had it under 2.6.27.4 on my Dell XPS 1530, as one of two
> problems (the other was frequently dropped connections);
> leaving the laptop idle, but connected, for more than 30mins
> was sure to trigger it.  I've now been up under 2.6.28-rc2 for
> 36hrs running, w/o any dropped connection and without any
> crash -- connected to a DLink 802.11n access point with no
> WEP/WPA.
> Bernard Moret

Thanks!

Do other users have similar experience? Noah?

Reinette


