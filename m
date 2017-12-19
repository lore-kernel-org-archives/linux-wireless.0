Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34728 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934408AbdLSJmV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 04:42:21 -0500
Message-ID: <1513676538.26145.5.camel@sipsolutions.net> (sfid-20171219_104236_175385_055AD2DA)
Subject: Re: [PATCH] wireless: Always rewrite generated files from scratch
From: Johannes Berg <johannes@sipsolutions.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Dec 2017 10:42:18 +0100
In-Reply-To: <20171214133338.10551-1-thierry.reding@gmail.com> (sfid-20171214_143342_018155_9B320A42)
References: <20171214133338.10551-1-thierry.reding@gmail.com>
         (sfid-20171214_143342_018155_9B320A42)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-12-14 at 14:33 +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Currently the certs C code generation appends to the generated files,
> which is most likely a leftover from commit 715a12334764 ("wireless:
> don't write C files on failures"). This causes duplicate code in the
> generated files if the certificates have their timestamps modified
> between builds and thereby trigger the generation rules.

Yes, d'oh. Applied, thanks.

johannes
