Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30644 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbbJaTMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2015 15:12:42 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Pushpal Sidhu <psidhu@gateworks.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Intel 7260 - limited in 5GHz spectrum
Date: Sat, 31 Oct 2015 19:12:38 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E8B86B4@hasmsx107.ger.corp.intel.com> (sfid-20151031_201245_671086_717A0BBD)
References: <CAD1M061nR5s6MFLHtoYDk05Ewz_3SHevB6s7qTB59qz681NLUg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 10/30/2015 06:37 PM, Pushpal Sidhu wrote:
> Hi,
> 
> I've been working with the Intel 7260 card which advertises itself as
> dual band wireless AC card. However, I cannot get it working in AP
> mode in the 5GHz range. An $(iw list) shows that the entire 5GHz band
> has 'no IR' next to it so as not to allow device radiation (please see
> pastebin here: http://pastebin.com/T4BWnBmn).
> 
> After searching around the internet a bit, it seems that the card
> doesn't allow for this mode (And is thus not really dual band?). I'd
> like to know if this is a firmware limitation and if there's a fix in
> place, or if not, why is this card limited to the spectrum it can
> radiate at?
> 


7260 does not (and will not) support AP mode in 5GHz band. This is of
course not a hardware limitation since it can function as a station in
this band. The limitation is due to regulatory concerns. Later devices
(8260) have the ability to be an AP in 5GHz under certain circumstances.
