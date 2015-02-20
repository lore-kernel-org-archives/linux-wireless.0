Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from omr1.cc.vt.edu ([198.82.141.52]:58012 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbbBTBDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 20:03:16 -0500
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ArikX Nemtsov <arik@wizery.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] cfg80211: Add API to change the indoor regulatory setting
In-Reply-To: Your message of "Fri, 20 Feb 2015 01:53:44 +0100."
             <20150220005344.GF20824@wotan.suse.de>
From: Valdis.Kletnieks@vt.edu
References: <1422889166-29386-1-git-send-email-ilan.peer@intel.com> <20150206235802.GA19988@wotan.suse.de> <CB3B3D4774441E42AA3EA0E1BA8230A04D01068E@HASMSX106.ger.corp.intel.com> <20150210200027.GG19988@wotan.suse.de> <CB3B3D4774441E42AA3EA0E1BA8230A04D017CEB@HASMSX106.ger.corp.intel.com>
            <20150220005344.GF20824@wotan.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1424394185_1945P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Thu, 19 Feb 2015 20:03:05 -0500
Message-ID: <36119.1424394185@turing-police.cc.vt.edu> (sfid-20150220_020350_980618_0CBB52E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1424394185_1945P
Content-Type: text/plain; charset=us-ascii

On Fri, 20 Feb 2015 01:53:44 +0100, "Luis R. Rodriguez" said:
> Wider community:
>
> anyone aware of any *need* in the kernel to know whether one is indoor or
> not on a device running Linux other than wifi? Clearly it should be something
> that might be of interest to at least other RF devices, so that is at least
> one possibilty to consider already, but what else?

I can think of a lot of reasons for the kernel to make indoor/outdoor
status available to userspace, but am coming up empty why the kernel itself
should care....

--==_Exmh_1424394185_1945P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVOaHyQdmEQWDXROgAQJSJw/9FmjgQdrU8Cb2BQBYNZ6jfXuG0Fh0rYfc
XBP3OzLsq26Ka/S5E4QXGE+pQjPEoMmH4qZwCItQZTkSbcEpEcMZiS8afC1EFN19
nGd7rPMvHvGW1gFvKhurYPBaEzce4rzQBfrbJ2Dz6qPQGSObZsF1NdOtPE1L7eyb
joj3C82DKUuOIeJ8akeCPmMQmJIuFeqlo7AX3kMTzUOU/AIpUbAN6IIEb2XA13nw
ml9/XgtZZ8c7Dt+F4XSAex2eoUIEvdPEYYy8UXxnhT5LxLONh7n+bVR4Auvbq2Gd
eohpLCgIsmGJZ/JKm1hKBwKOOC/DoxWiC2OmMzDXimcS4dSy5BKxTYHpH/gTxS94
Xm1Vd+Ro6T3KlRAsVtBheg4vzOGH8tqtbj2A7mPLWC6+THKZhk6i04dc8fqPw7Le
fdXDeobCe3TKoDD3MoBnLlFgE3eWVd/BiPa7gmL0Q5DNWcdhrqZ4GmV7r3TNTHt6
Cfj3/vB46zzqsUY5BOhigCTndSz+g7DPGp8C7+5p016xXMCwuN7JJoqcj5SBxA17
a3+CN0Qc+Oo0ouAi0Yg+qEsHiBkYq2kWfMFt02YlTjFGCA/o/ouK/C2TRiBbHCl/
6VJxAV8hPIW+tbJm3EQvqXWKdpPR789CP4op6dpOmerR8GBhx0BCLBpAGavMzZyD
PuGYBbRhkWo=
=+Pxw
-----END PGP SIGNATURE-----

--==_Exmh_1424394185_1945P--
