Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbZIMXxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2009 19:53:10 -0400
Subject: Re: [ipw3945-devel] [PATCH 09/13] iwlwifi: clean up ht config
 naming
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240909131645o3254764y84b4eb807c251936@mail.gmail.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
	 <1252690699-25796-10-git-send-email-reinette.chatre@intel.com>
	 <1ba2fa240909131645o3254764y84b4eb807c251936@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ED5aoOU5bJwsoDYq9aRw"
Date: Sun, 13 Sep 2009 16:52:35 -0700
Message-Id: <1252885955.23427.35.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ED5aoOU5bJwsoDYq9aRw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-14 at 02:45 +0300, Tomas Winkler wrote:
> On Fri, Sep 11, 2009 at 8:38 PM, Reinette Chatre
> <reinette.chatre@intel.com> wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> >
> > Daniel Halperin pointed out that the naming
> > here is rather inconsistent with at least 3
> > different names being used for one thing in
> > different contexts. Rename the struct to
> > iwl_ht_config (rather than iwl_ht_info) and
> > use ht_conf as a variable for it.
>=20
> Hmm. ht_info was used to describe protocol handshake info (as
> described by spec) while ht_configis actual HW configuration
> constrained by HW capabilities or current state I didn't follow
> closely current changes but at least they used to be not the same
> things.

Umm ... what am I supposed to read out of this comment? The code before
this patch intermingled info and config (i.e. HW config and protocol
config) and we're trying to clean that up.

johannes

--=-ED5aoOU5bJwsoDYq9aRw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKrYW/AAoJEODzc/N7+QmaneYQAMbBcpRATS808A/qItA3e3eo
preCAs55x6GlUVjz2KCggj0JUdzmUOHBzh3Jvhz3F+UIoH6d2emd1qa2Aid8O/gX
2WvfnyCP/DUuTVzojZLnea+Xxzo3HL5d+0/eThreIszhC1bmjCbS0XnmxlcuZQFJ
5/eD+yY4dmaZCEFPU9su1jEGkQbUrzBFejs41JT7i5TbRz/NP4g0F6B1CkjhVACb
MTLZkdoQM31oU7TZHYvUEgWwPjl4BfsM0fzoE+7Uihfzk8Kwc6drOa9mCEScqbgZ
sMc9k8XAL5btPLSM1XwctLwev3SPv9bygLLhvjL749m2CD8IODZLqH/swJGmG4M/
uBM3AJUUElNoEentZMZpIfa/9KCSvr9muGlY0T1KUUqwD8NBrwCFH2MefN5MBa//
rNH8DEwgIXYFGbOCAemuScTabhoF9PpklOIEPiSf3fKKG4jkGdT7I/bQ2VSBB3tW
h7ClirtQ/cK+sqWYAXFg7kCLxcV1Xfhf6Zn8OERYsx7E4EYqRVWLTjUet0ZH67e6
BZzpALbg6vMGZJpvgSeZNlLBEcsvMDBpF2lFfSnR+7MnmIUs+FcnS4U5YNMMJn4V
qkhzw9FgHIe+uSOKkFS3zFG2/8rwKt0QSPcUp4I1qhOWr3XuWBF49z29KKbamYP2
MroQIGtFZJ/g79edys8m
=5zli
-----END PGP SIGNATURE-----

--=-ED5aoOU5bJwsoDYq9aRw--

