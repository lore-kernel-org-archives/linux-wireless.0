Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:58244 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146AbaAWUBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 15:01:01 -0500
Date: Thu, 23 Jan 2014 22:00:45 +0200
From: Petko Manolov <petkan@nucleusys.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi crash with 3.13
Message-ID: <20140123200045.GA4064@localhost> (sfid-20140123_210106_608497_B27DEF4A)
References: <20140123091659.GE9077@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D56D70@HASMSX103.ger.corp.intel.com>
 <20140123123125.GA3424@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 14-01-23 12:45:30, Grumbach, Emmanuel wrote:
> >
> > Ok - thanks.
> > Can I see the output of
> > 
> > cat /sys/kernel/debug/iwlwifi/*/iwlmvm/nvm_sw | hexdump | head -5
> > 

I don't have iwlwifi entry in /sys/kernel/debug.  My kernel is probably missing some config switches.

> If it easier - you can also reload the module and add debug=0x1:

Well, it wasn't easier.  I got multiple "invalid module parameter" sort of error before i realized CONFIG_IWLWIFI_DEBUG should be on. ;)

> modprobe iwlwifi debug=0x1.

Attached is the dmesg output.  It is 'xz' compressed as it was 150KB hog.

> Note that you first need to unload iwlmvm, then, unload iwlwifi. After that you can reload iwlwifi.
> I prefer the debufgs line above though, I'll get a bit more information.

Mgh, no such entry.  If you can point me as to what else i need to enable in my kernel config...

--u3/rZRmxL6MmkK24
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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

--u3/rZRmxL6MmkK24--
