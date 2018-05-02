Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55818 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbeEBMhL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 08:37:11 -0400
Message-ID: <1525264627.6911.8.camel@sipsolutions.net> (sfid-20180502_143719_922225_43B48A09)
Subject: Re: [wireless-regdb] [PATCH 2/2] wireless-regdb: Parse wmm rule data
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
        linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Date: Wed, 02 May 2018 14:37:07 +0200
In-Reply-To: <20180502123236.GA981@ubuntu-xps13>
References: <1525181772-30337-1-git-send-email-haim.dreyfuss@intel.com>
         <1525181772-30337-2-git-send-email-haim.dreyfuss@intel.com>
         <20180501200256.GM3502@ubuntu-xps13>
         <1525209561.25505.3.camel@sipsolutions.net>
         <20180502123236.GA981@ubuntu-xps13>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-02 at 07:32 -0500, Seth Forshee wrote:
> 
> I'm more thinking that for e.g. Debian if attr is installed via pip and
> not a distro package then that might be a problem for their package
> builds. But let's go ahead and leave it, if there's fallout we can
> figure that out later.

Fair enough, I don't really want to use pip on any of my systems either
:-)

Seriously though, it's packaged in Debian, Ubuntu and Fedora, which is
all I use, but it's a pretty common package.

johannes
