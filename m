Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52628 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757177AbdJKIFV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 04:05:21 -0400
Message-ID: <1507709118.908.219.camel@coelho.fi> (sfid-20171011_101043_212015_364C1BEB)
From: Luca Coelho <luca@coelho.fi>
To: Joel =?ISO-8859-1?Q?Bjurstr=F6m?= <maxxflow@gmail.com>,
        linux-wireless@vger.kernel.org, assaf.krauss@intel.com,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com
Cc: linuxwifi@intel.com
Date: Wed, 11 Oct 2017 11:05:18 +0300
In-Reply-To: <1507092741.908.56.camel@intel.com>
References: <981d5fb9-4c3f-be8e-265a-6d21a2591e40@maxxflow.com>
         <d3356a70-b90e-d0cc-6328-17f055b2ed1c@maxxflow.com>
         <1507092741.908.56.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi: ToF usage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-04 at 07:52 +0300, Luciano Coelho wrote:
> Hi Joel,
> 
> Unfortunately we don't have full support for ToF on the mainline
> kernel
> yet.  But you can try to use one of our Core releases (which is a
> backports-based tree) that you can find here:
> 
> You could try the release/Core30 branch, for example.


Johannes has also created a patch on top of the latest iw tool, adding
the commands for ToF.  Please see my comment in this bugzilla entry if
you want to try that:

https://bugzilla.kernel.org/show_bug.cgi?id=197187#c1

Also, if you have any problems, please add it to bugzilla so we can
track this all in a single place.

--
Cheers,
Luca.
