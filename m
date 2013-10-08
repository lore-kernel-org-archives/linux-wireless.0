Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:18081 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab3JHF1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 01:27:11 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Steve NJ <stevezlatev@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: RE: [Ilw] Driver for 7260-AC (Mint15)
Date: Tue, 8 Oct 2013 05:27:06 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DBD5B6@HASMSX103.ger.corp.intel.com> (sfid-20131008_072718_896647_F5993D3C)
References: <CAK6YWsnC=wLcHGOpcp01rpbEL2Ns=Ds0j=758WkheD0DOuhcQA@mail.gmail.com>
In-Reply-To: <CAK6YWsnC=wLcHGOpcp01rpbEL2Ns=Ds0j=758WkheD0DOuhcQA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>Hello,
>Mint15 does not recognize the the new 7260-AC card outright. and the installation instruction are lackluster at http://wireless.kernel.org/en/users/Drivers/iwlwifi
>Could you give me a headups how to get it working.
>Thanx
>--S

Please contact your distro. This device is supported starting kernel 3.11. You can also opt for the backport solution: https://backports.wiki.kernel.org/index.php/Main_Page.
