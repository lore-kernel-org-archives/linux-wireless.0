Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36072 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAYTsW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 14:48:22 -0500
Message-ID: <1516909700.2189.7.camel@sipsolutions.net> (sfid-20180125_204826_226284_6D263BF1)
Subject: Re: [PATCH v3] mac80211: mesh: fix wrong mesh TTL offset calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <peter.oh@bowerswilkins.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 25 Jan 2018 20:48:20 +0100
In-Reply-To: <d5398ece-5ca2-19ba-7d18-c103283e2e96@bowerswilkins.com>
References: <8582518b7f032acfa598faf7d26c765b09149e90.1516842930.git.peter.oh@bowerswilkins.com>
         <d5398ece-5ca2-19ba-7d18-c103283e2e96@bowerswilkins.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-01-25 at 11:01 -0800, Peter Oh wrote:
> Ignore the patch below for now. Just noticed mesh_chansw_params_ie is 
> constance.
> 
Just remove the const?

johannes
