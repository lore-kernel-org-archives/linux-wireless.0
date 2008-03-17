Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:14690 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbYCQUUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 16:20:19 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6540284wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 13:20:18 -0700 (PDT)
Message-ID: <1ba2fa240803171320s1a14bfa1kbb79ee1fc6a79287@mail.gmail.com> (sfid-20080317_202024_365450_6893B88F)
Date: Mon, 17 Mar 2008 22:20:17 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 2/5] mac80211: allows driver to request a Phase 1 RX key
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205784149.16475.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205608293.15910.53.camel@johannes.berg>
	 <1ba2fa240803161704r36b5df43q33c953d698b88590@mail.gmail.com>
	 <1205753998.1614.34.camel@johannes.berg>
	 <1ba2fa240803170603g58cd5378n4e8e58b62c41c37c@mail.gmail.com>
	 <1205759599.1614.69.camel@johannes.berg>
	 <1ba2fa240803170745x4d70cc0esd4b49ebf85d68267@mail.gmail.com>
	 <1205766247.1614.111.camel@johannes.berg>
	 <1ba2fa240803171254j2709011ax7522bb05ded04aeb@mail.gmail.com>
	 <1205784149.16475.30.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>  You mean "RX in push mode" I think. Could you change that to a new
>  callback or so then as we discussed?

Yes

>  johannes
>
