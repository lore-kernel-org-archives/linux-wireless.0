Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:48656 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbYCSVUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 17:20:33 -0400
Received: by ti-out-0910.google.com with SMTP id 28so306646tif.23
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2008 14:20:31 -0700 (PDT)
Message-ID: <f6ca9fed0803181601w171564a5y337ed77394b3835e@mail.gmail.com> (sfid-20080319_212131_799612_BA7643E2)
Date: Wed, 19 Mar 2008 00:01:10 +0100
From: drago01 <drago01@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [ipw3945-devel] iwl3945 rfkill regression
Cc: "Dan Williams" <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <D936D925018D154694D8A362EEB0892003F2D621@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0801221204j71ad2137l19555363e46a7e45@mail.gmail.com>
	 <1ba2fa240801261411x7bb437c9s31aea593537afeba@mail.gmail.com>
	 <47B29F63.6050605@gmail.com>
	 <D936D925018D154694D8A362EEB0892003A7F599@orsmsx416.amr.corp.intel.com>
	 <f6ca9fed0803181232n4ac188ev5d10e7c68aad57aa@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892003F2D487@orsmsx416.amr.corp.intel.com>
	 <f6ca9fed0803181446v139b688ek958ce29cf7d98457@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892003F2D574@orsmsx416.amr.corp.intel.com>
	 <f6ca9fed0803181520h197dbe53ia4afa125cba2f467@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892003F2D621@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 18, 2008 at 11:36 PM, Chatre, Reinette
<reinette.chatre@intel.com> wrote:
> On Tuesday, March 18, 2008 3:20 PM, drago01  wrote:
>
>  >
>  > The problem is that NetworkManager puts the interface down when it
>  > detects the rfkill. And because the firmware gets unloaded NM never
>  > brings the device up again because it will always think the rfkill is
>  > on.
>
>  oh, I see ... what implications do you see if we ask NetworkManager not
>  to bring the interface down when it detects the rfkill?

good question, Dan?
Would it work to just don't down the device on rfkill? (threat it as
down without really bringing the physical device down)
