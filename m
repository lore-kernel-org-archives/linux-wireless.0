Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:8087 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbXILApo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 20:45:44 -0400
Received: by mu-out-0910.google.com with SMTP id i10so70259mue
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2007 17:45:43 -0700 (PDT)
Message-ID: <6b8cef970709111745k705462eay24a34355458c793b@mail.gmail.com>
Date: Tue, 11 Sep 2007 20:45:42 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix initialisation when built-in
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1189507832.6161.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1189507832.6161.16.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've tested that this patch, along with "[PATCH] cfg80211: fix
initialisation if built-in" fixes the initialization issues I was
seeing with the rt2x00 driver when built-in. Thanks Johannes!
